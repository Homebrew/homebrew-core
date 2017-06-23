class Tokei < Formula
  desc "Program that allows you to count code, quickly."
  homepage "https://github.com/Aaronepower"
  url "https://github.com/Aaronepower/tokei/releases/download/v6.0.1/tokei-v6.0.1-x86_64-apple-darwin.tar.gz"
  sha256 "ac62187453747125b473b1a540e788097ae309fccff3ba71007c7a882db46aea"

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
