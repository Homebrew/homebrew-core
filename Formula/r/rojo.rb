class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.4.4",
      revision: "5bd3c74db023c5588612bc73caace5f8d3a265b9"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b347770f99c287b7be97f763d9c2a0cad3f4da666564dbc8b028658d9c2aac9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "124502f09f177403d38bafe52c9392ce46ac6063daeb0244a1bf1c1e9df76369"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b24719dba60457c261697e46cf3a0fe187c5edd990f644271dd33348b40506c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c490667709f9c7ecdb2b5ad22591255700b981e191c6ad1d38a724a72f53a2b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd37712e2fec0ea5912b0203916ab176806daf02a798f3355427965551317b38"
    sha256 cellar: :any_skip_relocation, ventura:        "06e415405c965afa0f0845a86e664c92f083f39c4c3e072ac22aaa27d6d3f7e4"
    sha256 cellar: :any_skip_relocation, monterey:       "2091fae5e8336a3e06bc0d676c6d005565ec1b75ec53475e7ee686fb092b2854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d455bb69759f1d0030ef0d1a7ee8a182f682eb169169c3c5084e0dca263ecc68"
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
