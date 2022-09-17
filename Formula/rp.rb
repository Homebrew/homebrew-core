class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://github.com/0vercl0k/rp"
  license "MIT"
  head "https://github.com/0vercl0k/rp.git", branch: "master"

  stable do
    url "https://github.com/0vercl0k/rp/archive/refs/tags/v2.0.2.tar.gz"
    sha256 "97aa4c84045f5777951b3d34fdf6e7c9579e46aebb18422c808c537e8b1044da"

    # Add ARM64 support. Remove in the next release.
    on_arm do
      patch do
        url "https://github.com/0vercl0k/rp/commit/da82af33da229dc98da7f7be8b3559c557924273.patch?full_index=1"
        sha256 "6cd21e38acbb7a4ef15272019634876bdc9c53ca218b4956abda09f9b8b3adc5"
      end
      patch do
        url "https://github.com/0vercl0k/rp/commit/7a2ffb789c0bf8803b31840304bc66768f56e6cf.patch?full_index=1"
        sha256 "ae63c6e9958fdbd55f4906cd3c53ae47d7fd160182d44fd237b123809bf9cbf0"
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "470af1a486ea35fe801dbc487a1a0cd1b855fdeffe68532f3b1110efa841f8e2"
    sha256 cellar: :any_skip_relocation, big_sur:      "afe31e255f4d94101d0a11fd9625937c5f1846dd21fd4189304295cdb8bcf3e0"
    sha256 cellar: :any_skip_relocation, catalina:     "f173bd7e78a13f9fe20fbe70e3bda26e91a5aec77bd094a4d0b447afee0ff1b9"
    sha256 cellar: :any_skip_relocation, mojave:       "9e7dee319426b8db92302fdd19ee37f3ea5b0b3b8ebb1865e29127aa340ec7b5"
    sha256 cellar: :any_skip_relocation, high_sierra:  "40042ba7ad3506a62f79ed836480bf2d33a3ea171a19905a51db60c3a037cb0b"
    sha256 cellar: :any_skip_relocation, sierra:       "93aea19e1b6c6511e309f87003f173485a36e2b870734b6162e0bc43ae5f2a70"
    sha256 cellar: :any_skip_relocation, el_capitan:   "1ed1c49f3495c6da683908c34d17f345c5f3bde2a5112674bbd41f6a92da1ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ff4254026a73200222f6c631c92d97ffc1c9ac36027089139f085fdf9163f812"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    os = OS.mac? ? "osx" : "lin"
    rp = buildpath.glob("build/rp-#{os}-*").first
    bin.install rp
    bin.install_symlink bin/rp.basename => "rp-#{os}"
  end

  test do
    os = OS.mac? ? "osx" : "lin"
    rp = bin/"rp-#{os}"
    output = shell_output("#{rp} --file #{rp} --rop=1 --unique")
    assert_match "FileFormat: #{OS.mac? ? "Mach-o" : "Elf"}", output
    assert_match(/\d+ unique gadgets found/, output)
  end
end
