class ZeldaRothSe < Formula
  desc "Zelda Return of the Hylian SE"
  homepage "https://www.solarus-games.org/games/the-legend-of-zelda-return-of-the-hylian-se/"
  url "https://gitlab.com/solarus-games/games/zelda-roth-se/-/archive/v1.2.1/zelda-roth-se-v1.2.1.tar.bz2"
  sha256 "1cff44fe97eab1327a0c0d11107ca10ea983a652c4780487f00f2660a6ab23c0"
  license all_of: [
    "GPL-3.0-only", # lua scripts
    "CC-BY-SA-4.0", # data files
  ]
  head "https://gitlab.com/solarus-games/games/zelda-roth-se.git", branch: "dev"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3bf751b6f5b6313d54d4c4356a07dbad2134d30574d18706a761272ad4fef7c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7b160b73bd9daf53b08f48c16e6642a054c2823114f7651d83270ab468694064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac1a274fde9642cae0d2b67f7d4589a57f91d5229c83293be45f612fc75b2553"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f6f18d2ea37dd7ddd63d5a050a9944e184d0db94f89fe54c6ad376a0464b65b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1f9b1fadb798f87d38698f31a0bc8cfb36c21c272087a25fc50256de704d379"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e526691edaef39b1c1d1ab41b09bf2d821d156c89d7ca6dd585e8599024742f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2f38f89648a88d61b5b087e1902175fb208f94764ea1cbd2783ed732d1332c9"
    sha256 cellar: :any_skip_relocation, ventura:        "2bff31ad635bfa2e8a1b135e3f100b1c24d70682ad915af130e5af9c70d5f873"
    sha256 cellar: :any_skip_relocation, monterey:       "bd2099609e574fa6b5703c40455f7d7187eda55f938d7418bf4eb2dd68a1dd66"
    sha256 cellar: :any_skip_relocation, big_sur:        "28b1bd5308092389db177a9b277a29f1da892c1a4a71dd9b12e483a045e52808"
    sha256 cellar: :any_skip_relocation, catalina:       "1531cd6fc89cca4cc08287e569cdd8b86e41a52bb8c66fb10f6a74bb5006bc24"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "77a60187f3e237fcdb9b1bfa6346d90cb2db5a4a07a3a74488432c94c84389c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f752b830f0e4e894b560e50ee2418fb889c938ddcdfc85fe9011a528647173e8"
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
    system "unzip", share/"zelda_roth_se/data.solarus"
  end
end
