class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.2.0.1",
      revision: "321295fba49fb66ede365afbd9ef62971cdfbfca"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "bc85f64768e494482a19797e4fc2ed1c116a374ba6dd7f30b4a33fc7db13555b"
    sha256 arm64_big_sur:  "9d0863dd30ca3234df2cd754e7eeef970c9cc0d78ee87a03458e1cd88eb85357"
    sha256 monterey:       "f721cdd00592267dad989844228c2d36df824829b80512f503456ae04913fa15"
    sha256 big_sur:        "5c2c8947a6cbc27093e2d97539ecd42a860588c4fb5595d0481a471d99916acb"
    sha256 catalina:       "9349f14593757fe6c896f6a20378471e8ba456aba766921858c2a8fb512cb028"
    sha256 x86_64_linux:   "5a3a2f4af23c41d2dca63ad6e16814adb2a4132da71bcd1f7402f25a29e2c259"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.10"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/50/ec/1d687348f0954bda388bfd1330c158ba8d7dea4044fc160e74e080babdb9/Mako-1.2.0.tar.gz"
    sha256 "9a7c7e922b87db3686210cf49d5d767033a41d4010b284e747682c92bddd8b39"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    python = "python3.10"
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
