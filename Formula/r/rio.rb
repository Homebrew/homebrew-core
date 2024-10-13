class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.1.17.tar.gz"
  sha256 "2e17a8775a5463f4ad96e55b90468561b08636d8d260bb295770aef930168000"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "becbe9dce23151a5ed99733efb7460ed6d3cdb291980fb53c9962933244fb192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "658c344e4cad8367cfc7aa03680fb1875b4602805c9dc0064d02539a22e1e3cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cd3c87ff261346dcf1532fe5457375671fbeb264b10c9645bd739f97e5f97c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "06db233ecf5afe5cbc4a943df41feb2baeab74073bd44fadc90af152b7ac29b7"
    sha256 cellar: :any_skip_relocation, ventura:       "b2c48e6fe92cb6e7c209fdd6a06b0241e7016e54758ea84b47a6da0e0a4fc2e9"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end
