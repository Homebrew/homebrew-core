class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://github.com/lance0/ttl/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "8222dedac1d47cd5eaa446cb8f229e8411e376a4652466111eb137058bfea05f"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      ttl requires elevated privileges for raw socket access.
      You should be certain that you trust any software you grant such privileges.

      On macOS:
        sudo ttl <target>

      On Linux (recommended):
        sudo setcap cap_net_raw+ep #{opt_bin}/ttl
        ttl <target>
    EOS
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
  end
end
