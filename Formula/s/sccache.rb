class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "309edaf43f44088e55e99ce14eb9cfdee8f85acad290171ebfd29eb9e368def3"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c05828146c2b4d0b5e97851faf0528392ad38db1370678be4ee782d212a373d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a56fad33d0363b873422aa48afcd1d206b59d5888b96638fd3aa6fc9f3cf126"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04737c5e48e81a0e164aebd0aa7af6749b63bb8ef23fadf01fd2bc2462f3b877"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ab23741213e6031678d7622e72e623d5503d1d5c75ed02cce0761115b44a03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0f8b613f29c5a27438dd40967f50992ad9d99b3a422bd50d6020ff12dc76812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb5ab9d593a391fab2ef0df44db64eafa22836c17cbc9a38c64aafeb6d679bc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
