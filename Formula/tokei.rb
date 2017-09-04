class Tokei < Formula
  desc "Program that allows you to count code, quickly."
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v6.1.2.tar.gz"
  sha256 "736bab89800c397acc3be961af12b80acc2ca71dc990792fff8935018a2f0698"

  bottle do
    sha256 "5043db8a4435292072d55c1501bc0bdd925090d847bfc745bf1bf338c56a08db" => :sierra
    sha256 "0541c9f195f710ef4b9424676b169ec68f5888db79f751a51d7132640922c059" => :el_capitan
    sha256 "bba5dac397ea4242f234e26d187487b39d2925b7d5f4795ecf8cdd2f5aea6b7e" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/tokei"
  end

  test do
    (testpath/"lib.rs").write <<-EOS.undent
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
