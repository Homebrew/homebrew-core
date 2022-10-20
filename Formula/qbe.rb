class Qbe < Formula
  desc "Compiler Backend"
  homepage "https://c9x.me/compile/"
  url "https://c9x.me/compile/release/qbe-1.0.tar.xz"
  sha256 "257ef3727c462795f8e599771f18272b772beb854aacab97e0fda70c13745e0c"
  license "MIT"

  livecheck do
    url "https://c9x.me/compile/releases.html"
    regex(/href=.*?qbe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ede097fbd833309d4afb675ef089aee3fe5bff6fced0a5551dc4111688ed31a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72c102e7eb668d52ea3d369450d30d19b0272d3bfe35049cf99d0c003bd7ff98"
    sha256 cellar: :any_skip_relocation, monterey:       "62feb0473090724b350a1a8a5afa8ee48f0e3d9062e5afce63a4d690ec2c9a5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f042b0d40491ed8ff1641814abd41ff67584405dce9f1c112b96b787b8c7d8e"
    sha256 cellar: :any_skip_relocation, catalina:       "f840bba007e227ace59e8cd04df766c2610c1b28331ec90f46c35d17e7db4924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cff072dab5d807051b2371e810c57cdcff9e27d7720a1d25c11d9ed0803c56"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"main.ssa").write <<~EOS
      function w $add(w %a, w %b) {        # Define a function add
      @start
        %c =w add %a, %b                   # Adds the 2 arguments
        ret %c                             # Return the result
      }
      export function w $main() {          # Main function
      @start
        %r =w call $add(w 1, w 1)          # Call add(1, 1)
        call $printf(l $fmt, ..., w %r)    # Show the result
        ret 0
      }
      data $fmt = { b "One and one make %d!\n", b 0 }
    EOS

    system "#{bin}/qbe", "-o", "out.s", "main.ssa"
    assert_predicate testpath/"out.s", :exist?
  end
end
