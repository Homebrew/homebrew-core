class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.3.0.0",
      revision: "1f8fd3457dee48dc472446113a6998c2529adf59"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
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
    url "https://files.pythonhosted.org/packages/6d/f2/8ad2ec3d531c97c4071572a4104e00095300e278a7449511bee197ca22c9/Mako-1.2.2.tar.gz"
    sha256 "3724869b363ba630a272a5f89f68c070352137b8fd1757650017b7e06fda163f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
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
