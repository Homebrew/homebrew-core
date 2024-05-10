class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  stable do
    # The build system uses git to recover version information
    url "https://github.com/EttusResearch/uhd.git",
        tag:      "v4.6.0.0",
        revision: "50fa3baa2e11ea3b30d5a7e397558e9ae76d8b00"

    # Backport fixes for build failure with `boost` 1.85.0. Remove in the next release.
    patch do
      url "https://github.com/EttusResearch/uhd/commit/c4863b9b9f8b639260f7797157e8ac4dd81fef93.patch?full_index=1"
      sha256 "5e5a90ba2fdaee109dccf0ca583d63e8848605eabff08b96187a408804b2910e"
    end
    patch do
      url "https://github.com/EttusResearch/uhd/commit/ea586168c596d13d05d145832519755794649ba0.patch?full_index=1"
      sha256 "224b3f0b726dc2eda982733a59009f34c0f70a0d2970a64755268ea237e86db3"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "15c59fae8381671f20e5f08e32d929b1cce61fdf8ead1aa0cf85c9bf101e3077"
    sha256                               arm64_ventura:  "61139c9b2c48f563e9993385eaeba2210c90a4ec1b306ca3888b261e528a9f61"
    sha256                               arm64_monterey: "442159ec407fa946db4e56bf2168e052fca6cb16ee72f0c87b36bb850a835fb5"
    sha256                               sonoma:         "3364bca9f3195744f4d1eb2712e8fc691cbf25ef9a106cc113f54b8d983268f1"
    sha256                               ventura:        "2f49ee5c1218cad92112c50d3f75686f4595c34853f964ff0851ea8a9857a725"
    sha256                               monterey:       "2aa7c3907b518d05b2bd33c7d4803b6713e794b744936ef13835504d0f58f238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d93b9305a06183f8c7deffd40dd8e60d2b92a02198a45f96f3460d9aa0a97f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.12"

  fails_with gcc: "5"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/d4/1b/71434d9fa9be1ac1bc6fb5f54b9d41233be2969f16be759766208f49f072/Mako-1.3.2.tar.gz"
    sha256 "2a0c8ad7f6274271b3bb7467dd37cf9cc6dab4bc19cb69a4ef10669402de698e"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    system "cmake", "-S", "host", "-B", "host/build", "-DENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "host/build"
    system "cmake", "--install", "host/build"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
