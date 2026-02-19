class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "81f04e80b246dbac7371da822ea22afa2411ec0bde0fd04fa575c9c1a52f8471"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "760699c2377dc0f5624ab15da20ae3e2283cc497a5ed9ac57b1b85a2df80954c"
    sha256 cellar: :any,                 arm64_sequoia: "457fb31dd150c9002f50fcd9bce9907fa11e5863c970c59657e4f04c08929dc5"
    sha256 cellar: :any,                 arm64_sonoma:  "d9913549a762e66598afe801150369ed3dbafead3bd85b88a1fe64e2c52fdce5"
    sha256 cellar: :any,                 sonoma:        "cc544dc0a7eed7f1b239caefabca618d6217d6f0954939ab350a6a809587de3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "582fe47be0a3bf56cc2696c21de8cc69ca636a92e3eb7bbd338be4f9c74cc0de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9a99c46d9f23a0ff48f46dfbc524f63066b52981b88af55d76ce009a3718f20"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end
