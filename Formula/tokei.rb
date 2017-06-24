# Documentation: http://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Tokei < Formula
  desc "A program that allows you to count code, quickly."
  homepage ""
  url "https://github.com/Aaronepower/tokei/archive/v6.0.1.tar.gz"
  sha256 "f7f455995fa4f14019bb2f3a5203d7b551d8c453e9b7a533de6fa8d707c7fd74"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/tokei"
  end

  test do
    (testpath/"lib.rs").write <<-EOS
  #[cfg(test)]
  mod tests {
      #[test]
      fn it_works() {
      }
  }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
