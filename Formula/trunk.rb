class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.7.1.tar.gz"
  sha256 "33b4b09a64a0d66be6de3de4d0bcffb0b624d7f49bbb8ce2ebc454485204fe55"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9b8cd96d4d13b560c963292a02ef324fe4210b882c2c3b3d0991a7fdd38b82c" => :catalina
    sha256 "922aecbb7cc7542846c46f49275d374bf867e3b1db3118902c16cb33cf39603e" => :mojave
    sha256 "03cc21c0906a089a51b2013c6adb9ecf0174726d6215bafd22badfac1d8197fa" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
