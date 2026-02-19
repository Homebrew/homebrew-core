class Rmrfrs < Formula
  desc "Filesystem cleaning tool"
  homepage "https://github.com/trinhminhtriet/rmrfrs"
  url "https://github.com/trinhminhtriet/rmrfrs/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "50fb55c8dba436998de87725427ee336045a2ee67d7ef9430ce875fcf8826d51"
  license "MIT"
  head "https://github.com/trinhminhtriet/rmrfrs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "767161879f6a4b4c0aa585e7fad656b07c9cea7e4c8136463fa80e6ecdc604d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e7469e0a2a38c0fbfce1fee1ff46b684eb549e4507d728f90236fc53d4afdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1abae95be3672118b8d43150bdd5c9a0682f52f4c5d667bf8b58d63783ecc2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "adc828072f5c3393d4890903cce6cdb30d9246c51b5e9a5c480582cf274bbd8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4898d3ac82f3bb77f6a9bca82cc0629c25d627ab1f59e96ed45a2d403c376ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0587d1e0f3b6be8ccbb3dda1e687c61369d6ccb268ae3d2d8ca36a61ed24bac7"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "rmrfrs")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "init"
    system "cargo", "build"
    assert_path_exists testpath/"target"
    system bin/"rmrfrs", "--all", testpath
    refute_path_exists testpath/"target"
  end
end
