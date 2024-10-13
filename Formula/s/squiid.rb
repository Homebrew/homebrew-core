class Squiid < Formula
  desc "Do advanced algebraic and RPN calculations"
  homepage "https://imaginaryinfinity.net/projects/squiid/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.1.2/squiid-1.1.2.tar.bz2"
  sha256 "f5d3564325aebf857647ff3dcb71ca4762cdedb83708001834f1afcbfacc5bbf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b17e72d4d22d88966111a63ae026a153f914204cbaa175fd7aaf2cadc9516b56"
    sha256 cellar: :any,                 arm64_sonoma:   "e65226dba5c635b6a7654119807167cd784609f3d6ee7fd229e066e3ddecc587"
    sha256 cellar: :any,                 arm64_ventura:  "192f669c507ed6e30b13a39574260ce3079c38dce77e290690444f4d053b0576"
    sha256 cellar: :any,                 arm64_monterey: "42573691dd99d9d27d4b8cfa669e942bb7af8fda09dca4cc58249a81a422c7f3"
    sha256 cellar: :any,                 sonoma:         "4a2ed2531fa98d783e72ca27c71f9ae06567ddd06fd8a14181505a4cd5f70e5d"
    sha256 cellar: :any,                 ventura:        "c59060acebc774af6e9021d34afb5a3f070a4d1a36c693c3ba20333f2581aeb7"
    sha256 cellar: :any,                 monterey:       "7a9c167de74de714e4a220922dfb4e147ad7c5c02c56f794d327210feee6ce12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c5e25463cfe0f9c83a8a6fb618829a70ddb496e54c08841a61a1b7f89c5d15e"
  end

  depends_on "rust" => :build
  depends_on "nng"

  def install
    # Avoid vendoring `nng`.
    # "build-nng" is the `nng` crate's only default feature. To check:
    # https://gitlab.com/neachdainn/nng-rs/-/blob/v#{nng_crate_version}/Cargo.toml
    inreplace "Cargo.toml",
              /^nng = "(.+)"$/,
              'nng = { version = "\\1", default-features = false }'
    inreplace "squiid-engine/Cargo.toml",
              /^nng = { version = "(.+)", optional = true }$/,
              'nng = { version = "\\1", optional = true, default-features = false }'

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # squiid is a TUI app
    assert_match version.to_s, shell_output("#{bin}/squiid --version")

    assert check_binary_linkage(bin/"squiid", Formula["nng"].opt_lib/shared_library("libnng")),
      "No linkage with libnng! Cargo is likely using a vendored version."
  end
end
