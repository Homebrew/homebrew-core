class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.8.0.0.tar.gz"
  sha256 "a2159491949477dca67f5a9b05f5a80d8c2b32e91b95dd7fac8ddd3893e36d09"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "ebaad7dcd0a6646f5bba5fb5d2ec4741caba9c9512a40ccc45876b91adda40f9"
    sha256                               arm64_sonoma:  "b81edc91475c72d0a15f1043619819316f3f268476dd5c416220c5ec16b30c23"
    sha256                               arm64_ventura: "bc397dbb79d7c69e12b2df8988fc4d36ffb1dcc1199c33acf322a10d5ebb73a3"
    sha256                               sonoma:        "88b4e190d80fc5342838f7aa22dfd2b8cb3a529455181cf0708e2af6cae83373"
    sha256                               ventura:       "477921aa456e442999d455a94068c158878e11f3fe6bc662f82c2c4a03476acc"
    sha256                               arm64_linux:   "23a80186cfe77cbba4fa2bbd2e088d0f4f7f2b28108e1966d3b76c35b53cd931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8e6f330239720cba66bd647287d85126b9f32cd0eac5d30aaff28539049ef7b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.13"

  on_linux do
    depends_on "ncurses"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5f/d9/8518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9/mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  # Support building with CMake 4.0, pr ref: https://github.com/EttusResearch/uhd/pull/849
  patch do
    url "https://github.com/EttusResearch/uhd/commit/8caa8e1d1adb6f73a30676f42c2c80041ccc4e9a.patch?full_index=1"
    sha256 "818dd3e65c7c25040887850713fa9bf9a3f6cf3ef791b1f73f7b8de12921452f"
  end

  # Support building with Boost 1.88.0, pr ref: https://github.com/EttusResearch/uhd/pull/850
  patch do
    url "https://github.com/EttusResearch/uhd/commit/16dbcb37976ca1e959d275f20246924fb455176e.patch?full_index=1"
    sha256 "0dc5cf491ca2037819e894fdb21b8b98230eb8ca2aee0d2312889e365da961e8"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    system "cmake", "-S", "host", "-B", "build",
                    "-DENABLE_TESTS=OFF",
                    "-DUHD_VERSION=#{version}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
