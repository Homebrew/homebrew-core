class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.7.1",
      revision: "26b6cc6d83ef068d356aac689110ad89f3b05d65"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "335bf302d850ace9fca1dc84480124a422c2f7e893af892c796424ea4eb19099"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c28a338cb94280fa09eab56ba5e0aebb04c37e25f1fe9b7057f6a193f34b12d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "32aa84cbdda37483593b3467a219728851956a9b55740ac0c2368d3de83d3872"
    sha256 cellar: :any,                 arm64_linux:       "457e913a7ee6a13cfbe28f48a9e718ba50c5c3ecb67039ba5214c6cdcc7fe132"
    sha256 cellar: :any,                 x86_64_linux:      "360c4db44167b1593191ab5129cba713fb2a5c12ba3cc5b963d49dfe848255d0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_path_exists testpath/"default.project.json"

    assert_match version.to_s, shell_output("#{bin}/rojo --version")
  end
end
