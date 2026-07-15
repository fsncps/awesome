# !/bin/bash
set -euo pipefail

# scale fonts for 1.5x UI on 1080p / cursor theme
xrdb -merge <<EOF
Xcursor.theme: Alkano-Amber
Xcursor.size: 24
Xft.dpi: 144
EOF

# --- Known monitor hashes -> roles ---
R4K_HASH="408df0074b553adf4cb27f07ce6b6e5d8428dfb1f96074e6f6fc7a9ab8661478" # DP-0 (4K)
L4K_HASH="2d39ffd507f96028f232179a1caad4cd92af395c4ebdb998dfb5f6bd01ea6caa" # DP-6 (4K)

# Fill this after you run the hash snippet once:
RHD_HASH="5d4d64cb1413114568f5751f47612a8ad7cfcefbb3fe02bd11caeaa775b4844f" # 1080p (right)

read_edid_hashes() {
    xrandr --prop | awk -v Q='"' '
    function flush(_,cmd,line,a){
      if(!grab) return
      if(edid!="" && state=="connected"){
        cmd="printf %s " Q edid Q " | sha256sum"
        cmd|getline line; close(cmd)
        split(line,a," ")
        print out, a[1]
      }
      grab=0; edid=""
    }
    /^[A-Za-z0-9-]+[[:space:]]+(connected|disconnected)/ { flush(); out=$1; state=$2; next }
    $1=="EDID:" { grab=1; edid=""; next }
    grab {
      t=$0; gsub(/[ \t]/,"",t)
      if(t=="" || t ~ /[^0-9A-Fa-f]/){ flush(); next }
      edid=edid t
      next
    }
    END { flush() }
  '
}

declare -A EDID_HASH
while read -r out hash; do
    EDID_HASH["$out"]="$hash"
done < <(read_edid_hashes)

# --- Map outputs to roles by hash ---
L4K=""
R4K=""
RHD=""

for o in "${!EDID_HASH[@]}"; do
    h="${EDID_HASH[$o]}"
    case "$h" in
    "$L4K_HASH") L4K="$o" ;;
    "$R4K_HASH") R4K="$o" ;;
    "$RHD_HASH") RHD="$o" ;;
    esac
done

# If RHD_HASH not set yet, infer it as "the remaining connected output"
if [[ -z "$RHD" ]]; then
    if [[ -z "$RHD_HASH" ]]; then
        for o in "${!EDID_HASH[@]}"; do
            [[ "$o" == "$L4K" || "$o" == "$R4K" ]] && continue
            RHD="$o"
            RHD_HASH="${EDID_HASH[$o]}"
            break
        done
        echo "Inferred RHD=$RHD  RHD_HASH=$RHD_HASH"
    fi
fi

# --- Sanity check ---
for v in L4K R4K RHD; do
    [[ -n "${!v}" ]] || {
        echo "Missing mapping for $v"
        exit 1
    }
done
echo "Mapped: L4K=$L4K  R4K=$R4K  RHD=$RHD"

# --- Layout ---
xrandr \
    --output "$L4K" --mode 3840x2160 --rate 60 --pos 1920x0 --primary \
    --output "$R4K" --mode 3840x2160 --rate 60 --pos 5760x0 \
    --output "$RHD" --mode 1920x1200 --scale 1.8x1.8 --rotate normal --pos 9600x110
