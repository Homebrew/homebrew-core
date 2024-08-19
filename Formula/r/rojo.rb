class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.4.3",
      revision: "f4e2f5aefc70541af61cfff248505c30d010c2a6"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98dd9ddbda3438950ae8ce6ef71dc6564f87b7a8abec94fc249d52c56049fb7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a512d6250a603631db2f81f743d08b6ceddfe645103dc3186f64158d6147af1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19968e3d3cc32fddaefb9ca6bc44a2ebbe07c15eb88d25de561a8fa7e86da25b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b82735e59a41d6952f32860c6ef7f9a1fb4988c6d85dcf257f2c810a9010e5bd"
    sha256 cellar: :any_skip_relocation, ventura:        "5fdd01f665cbff1fc75d285e75ad898ffb34eea247dee186c2b9ff4a45c8904d"
    sha256 cellar: :any_skip_relocation, monterey:       "ade4e91f28f6ffa31c67d4526d6f5233565514b2028d31ed4bb7f2f70953d4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6daa230e0b05ecb03d52616667220f42603faaf56872772960ba79b39dba7b43"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_predicate testpath/"default.project.json", :exist?

    assert_match version.to_s, shell_output(bin/"rojo --version")
  end
end
