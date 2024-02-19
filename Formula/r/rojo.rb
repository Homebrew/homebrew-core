class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.4.0",
      revision: "c0a96e38110c14e932c3319b8ae32a1aaf8f2e9b"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1899cd7667173520cf3c6526683700e7cd53678382db4ec7ca30cfc97ea73271"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44f215b65cea64d25d13cab268c31b31d45fc5a3a24eb1d1d5c28a34def81455"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b80eb12b33a15d40f34d35bf0feb1ecca030e78d65e84e008ddc1dd3da12ae1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf7c690903d9fa09a9b6e914675df86d645bd35616449a6d1525aa5dc593b2ce"
    sha256 cellar: :any_skip_relocation, ventura:        "1450ced9f59375ca1d8252ae77f30b41aa7e76a77e4434c25fcb528c0c6603d9"
    sha256 cellar: :any_skip_relocation, monterey:       "0c05ecf372e4b57565bdb7fb6de2042b9e080cdae73319f415cc39bf2fee4570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b722936fa8ac2f443f7db1885a09213ba42e356f4586bba2c9e3600857b1e74"
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
