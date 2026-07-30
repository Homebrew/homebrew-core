class Xfg < Formula
  desc "Sovereign private blockchain banking node suite"
  homepage "https://usexfg.org"
  url "https://github.com/usexfg/fuego-suite/archive/refs/tags/1.10.07.tar.gz"
  sha256 "dbc87c3a8ba2f4f526bb2c65686375b125791b307bca6c8878d22f95973726e4"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "icu4c@78"
  depends_on "jsoncpp"

  conflicts_with "fuego"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    cd "tui" do
      system "go", "build", *std_go_args(output: bin/"fuego-tui"), "."
    end
    cd "swapxfg" do
      system "go", "build", *std_go_args(output: bin/"swapxfg"), "."
    end
  end

  test do
    wallet_path = testpath/"test_wallet.bin"
    system "#{bin}/fire_wallet", "--testnet", "--generate-new-wallet", wallet_path.to_s,
           "--password", "test_password"
    assert_predicate wallet_path, :exist?
    assert_match "Fuego", shell_output("#{bin}/fuegod --help 2>&1", 1)
  end
end
