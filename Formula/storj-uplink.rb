class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.65.1.tar.gz"
  sha256 "05dfedab488e44aedb7d8d35ce9565fcb622b86b474b4613534726acaa9efccf"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "198fd8b500cefee1f87aa73606a0379c278c1eefb7c9d6c1142ef26d10908bb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "097e3bd19eabda76b0fe01db6f751232959534a869171730e6e12da29f0349f9"
    sha256 cellar: :any_skip_relocation, monterey:       "d7ed22ba996be491ef259d8cd4061c4eff72e3b634dc4b51715648ef8930a72c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ae31c937cf55f961700ac0c2d7aa7151f05ed28bd83c70fd397e38a544efe36"
    sha256 cellar: :any_skip_relocation, catalina:       "d8f5d3cc7b67866c612b9856c25097c0129ce3f9f4fd6df9338cc3ff6eda2c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c530f8093f60d388c95b9022fbe634907e120db3f6a1100ec0812238f61313b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
