class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.1.tar.gz"
  sha256 "6cf4833bbd562ff89c8165443e951fe7f6284a19417918431ac9b88cc2a6520b"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad7854f901ae4ac1ab4f7af7f02d4ee00d807789914515fd25b1c5b2c8c2ca04" => :big_sur
    sha256 "7c874d945d0ddd2893f9004e9b515a00ed384ad2359fb570bfab3dc7d81294a6" => :arm64_big_sur
    sha256 "3901a4b32d2fd8c576929b52603c2166f08978a228f8c18491b258c72f0777e9" => :catalina
    sha256 "65a04941f0c97cdb98ffdf3b4e16fe4640566d35b107b634bcd789779fa58deb" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init --home #{testpath}/staging")
    assert_true File.exist?(testpath/"staging/config/genesis.json")
    assert_true File.exist?(testpath/"staging/config/config.toml")
    assert_true Dir.exist?(testpath/"staging/data")
  end
end
