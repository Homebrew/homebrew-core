class Qbe < Formula
  desc "Compiler Backend"
  homepage "https://c9x.me/compile/"
  url "https://c9x.me/compile/release/qbe-1.1.tar.xz"
  sha256 "7d0a53dd40df48072aae317e11ddde15d1a980673160e514e235b9ecaa1db12c"
  license "MIT"

  livecheck do
    url "https://c9x.me/compile/releases.html"
    regex(/href=.*?qbe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e0f58c85a4bbf3b4eef38435d8bdfee9254a4e0311381e939d000311081c289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5318c7031f94916e283ab4161095171b6ab9cb6e6a9430ea6c5f0811568ab62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e00dce5f83a8cf7e9400c42234e5b63f670d99a2fdcbad487389f90093780bf2"
    sha256 cellar: :any_skip_relocation, ventura:        "0c919e700fb02acf816593311660d0269c621eabd2a3274d85d0a4496a00fef9"
    sha256 cellar: :any_skip_relocation, monterey:       "7a48c78d50eb35e007a17431b41d59f08a23ce911291bb9bdc13a0dab59f40ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "c56c49645beaec309145f55d36ca1cab8109f92621ce74f0d742350e6b30a05a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "182be378da98a564106defabd1377fba09bac76277e003a4c5f037d31ef89b82"
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
