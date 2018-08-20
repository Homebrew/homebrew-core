class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v7.0.3.tar.gz"
  sha256 "47848921f7f04fdd1ef515b2db25b931f97471f4b178c7914b3646251bcd8086"

  bottle do
    rebuild 1
    sha256 "e476d8501d7f2e2595fb877a87076f84444a2efd0908f967f2cbe0d8d230960f" => :mojave
    sha256 "573fad477decddf656f666848a3da572a8d903ff8b5352f712fb6535f52c83d2" => :high_sierra
    sha256 "fbc0cf15f958c8e4a5aeaf8b270aefbe97f2f2058e3c6a3dbc9b3268f032de38" => :sierra
    sha256 "ecb70caf0becbd065ebb3f23d8fa188e072c20b279f385e4bf118276eda53c12" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--features", "all"
  end

  test do
    (testpath/"lib.rs").write <<~EOS
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
