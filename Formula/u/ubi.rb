class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "54cf1c32adfdf4cb51ca0839aeac4538705edcc7aec384bdcd70d5acd45ce7b6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d719148206332fd1f2aae408d00b31c62021b963724bfb3e9de79afa32823fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f467b1755104d2c0e44752ff79d1a37a57ccc638e16566e94efd930f42609d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "268b61775aa2d86f1aec10a0b738b8d76f5d5f07e1feb2a61f6eec6970176fd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "464ce32c77eadb5f2fb549ba4f5194c5b2a060034a6c847c46d159a8a3124125"
    sha256 cellar: :any,                 arm64_linux:       "d9f6a854807ec46c47e4d40fba7b7548d21db666708e2a67040e5b189573b91c"
    sha256 cellar: :any,                 x86_64_linux:      "ad6ada44215ba1099094a8303dcb2618c5a505043387e09379d09d8f2c4e9484"
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
