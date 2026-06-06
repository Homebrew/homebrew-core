class StevenblackHosts < Formula
  desc "Unified hosts file with optional extensions"
  homepage "https://github.com/StevenBlack/hosts"
  url "https://github.com/StevenBlack/hosts/archive/refs/tags/3.16.87.tar.gz"
  sha256 "47963cac59f4bf11e1976636e7d08344261428e77f0540310aec98778964023d"
  license "MIT"

  def install
    pkgshare.install "hosts", "alternates", "extensions", "readme.md"

    (bin/"stevenblack-hosts").write <<~SH
      #!/bin/sh
      set -eu

      root="#{pkgshare}"

      usage() {
        cat <<'USAGE'
      Usage:
        stevenblack-hosts --list
        stevenblack-hosts --path VARIANT
        stevenblack-hosts --cat VARIANT

      Variants:
        base      Default StevenBlack hosts file.
        <name>    Directory name under alternates/.
      USAGE
      }

      variant_path() {
        case "$1" in
          ""|base|default|none)
            printf '%s\\n' "$root/hosts"
            ;;
          *)
            printf '%s\\n' "$root/alternates/$1/hosts"
            ;;
        esac
      }

      case "${1:-}" in
        --list)
          printf '%s\\n' base
          find "$root/alternates" -mindepth 1 -maxdepth 1 -type d -exec basename {} \\; | sort
          ;;
        --path)
          if [ "$#" -ne 2 ]; then
            usage >&2
            exit 64
          fi
          path="$(variant_path "$2")"
          if [ ! -f "$path" ]; then
            printf 'Unknown variant: %s\\n' "$2" >&2
            exit 66
          fi
          printf '%s\\n' "$path"
          ;;
        --cat)
          if [ "$#" -ne 2 ]; then
            usage >&2
            exit 64
          fi
          path="$(variant_path "$2")"
          if [ ! -f "$path" ]; then
            printf 'Unknown variant: %s\\n' "$2" >&2
            exit 66
          fi
          cat "$path"
          ;;
        -h|--help)
          usage
          ;;
        *)
          usage >&2
          exit 64
          ;;
      esac
    SH
  end

  test do
    assert_path_exists pkgshare/"hosts"
    assert_path_exists pkgshare/"alternates/fakenews-gambling/hosts"
    assert_match "fakenews-gambling", shell_output("#{bin}/stevenblack-hosts --list")
    assert_match "alternates/fakenews-gambling/hosts",
                 shell_output("#{bin}/stevenblack-hosts --path fakenews-gambling")
    assert_match "StevenBlack/hosts", shell_output("#{bin}/stevenblack-hosts --cat base")
  end
end
