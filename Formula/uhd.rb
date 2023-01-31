class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.4.0.0",
      revision: "5fac246bc18ab04cb4870026a630e46d0fd87b17"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "8f2a7c8a5b10bda08b72690100bf00f8a330ae248108f34b2cbcf84f118c3c18"
    sha256                               arm64_monterey: "c42265c7f7d09f0875a2db9b192c12dae5591398afee44d61f655228c213d962"
    sha256                               arm64_big_sur:  "15844c8d40345504625b7d4035186f530e30d6e5dbc9841097373d8f0deed2f7"
    sha256                               ventura:        "ca521e82eb8c68e80b2d428d01d6494bf2ad04363cbb3193a87acf54daadfd65"
    sha256                               monterey:       "d7f800563122444037cc7f8be53cdeabc5dd19e4b1e7156ac90efcb940918ac1"
    sha256                               big_sur:        "8d91add375503914d049074be80e43e1dc1be0700661c855f68842518d821894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "775da4623190e153bfb12326a6fbd4c8ccc96975f60db651df28bb5eaecafcdb"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.11"

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  def install
    python = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python)

    resources.each do |r|
      r.stage do
        system python, *Language::Python.setup_install_args(libexec/"vendor", python)
      end
    end

    system "cmake", "-S", "host", "-B", "host/build", "-DENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "host/build"
    system "cmake", "--install", "host/build"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
