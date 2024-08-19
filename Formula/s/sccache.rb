class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "30b951b49246d5ca7d614e5712215cb5f39509d6f899641f511fb19036b5c4e5"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9445c581fefc0228a6d7eb919ffe144e712202cf5f1daebbcf2704de948abae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "507c9974e7a268b18f4c5c895b45817a328773da80337196761c2d6d70c38f60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb8cefb8c0f8065c87e85059c699664904f5e6e2cc55bc221dd2fc6ecf662458"
    sha256 cellar: :any_skip_relocation, sonoma:         "275afdbfd37682c86aee198fc32867c8470ccbc7264765d0737865bc8096462d"
    sha256 cellar: :any_skip_relocation, ventura:        "a6e9e14187f20b1c6994332e05af34601229832bdd5b72d4c122e27f379fa2b9"
    sha256 cellar: :any_skip_relocation, monterey:       "f7e6a46b744ef7ecdd88facaf809281ce2310f827cd5d0600fb6a310474c6fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25e9e67a8fa6a94e150c83629220cb97da8a16cc83f00ddde9974e8a2d78f448"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system bin/"sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
