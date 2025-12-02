class Zsxd < Formula
  desc "Zelda Mystery of Solarus XD"
  homepage "https://www.solarus-games.org/games/the-legend-of-zelda-mystery-of-solarus-xd/"
  url "https://gitlab.com/solarus-games/games/zsxd/-/archive/v1.12.2/zsxd-v1.12.2.tar.bz2"
  sha256 "656ac2033db2aca7ad0cd5c7abb25d88509b312b155ab83546c90abbc8583df1"
  license all_of: ["CC-BY-SA-4.0", "GPL-3.0-only"]
  head "https://gitlab.com/solarus-games/games/zsxd.git", branch: "dev"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5f1f3d492a406445db86e75543b26e128ddf690e9c8360362185cbb564319112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7f0acd40f96b33fa5dfb02c86c7c5565d0c02043888ab1824e9c65bc515cbd8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "913089c3f580b340c83ee2a0146e76cc5537d8ace0b27a053413ad130e37e5b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3210e812054b1162800685d3a548822065dbe07053515f4e1185fe8a6c5a7fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee42ed381fd488a0e538e30eeff539346f71c0822fcc899907792fc4acc5988a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4092f599ecb1631608fe3a5109006480d6797bee0ec8b4cd4878b451f4400720"
    sha256 cellar: :any_skip_relocation, sonoma:         "228f4c7c85f5744241b193de33a84b8eabf7407cd0a4cd856817ec97ebb108e5"
    sha256 cellar: :any_skip_relocation, ventura:        "f79284e528dd5c8c412dfd90f96fc8d3d6c54ca839a8dd71fd7fb689c8ae7951"
    sha256 cellar: :any_skip_relocation, monterey:       "5641638453928b8d7dc434051961417e5c3e768c06fc35f9879737640027ece3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccae47d22a42e29f9d5d37fdd0be7cfa8f451d3b0f42d2db2b933f6a7ae1d129"
    sha256 cellar: :any_skip_relocation, catalina:       "aabcc393aae8f00a45ffa24d959ff57a6023caace90a815f8107c579e113b87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "81e1d2d168374d4baedd1ce60c4349439b049bc1d3f20dc3fa6ab2a0bc554297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b29f50a29f5874e4197504acbc4bd1f0162df77d8e30152a10c4bf82befc446"
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  uses_from_macos "zip" => :build
  uses_from_macos "unzip" => :test

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DSOLARUS_INSTALL_DATADIR=#{share}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "unzip", pkgshare/"data.solarus"
  end
end
