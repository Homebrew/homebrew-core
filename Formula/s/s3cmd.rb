class S3cmd < Formula
  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/b3/9c/ad4cd51328bd7a058bfda6739bc061c63ee3531ad2fbc6e672518a1eed01/s3cmd-2.4.0.tar.gz"
  sha256 "6b567521be1c151323f2059c8feec85ded96b6f184ff80535837fea33798b40b"
  license "GPL-2.0-or-later"
  head "https://github.com/s3tools/s3cmd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ba98097521dc3a454edba2847b2e49cab73954e17ef711698085b399ab855b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edd6fb636450b1f945071700ed8b57df1648930ce8e7f9647a2e7ea89233a87e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d81fcaafd0e92dcf2bd34dd0946751430f73d8033b91eb97889a21c8a61494c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e3a127172f90bebda2e5f9fb4b1ee441c1e16a40f8bd4c0e19a772452fb4f32"
    sha256 cellar: :any_skip_relocation, ventura:        "2b2021a272fa4f350b5112f7f76767511a035077e4de4075201c5c25b19ff995"
    sha256 cellar: :any_skip_relocation, monterey:       "d589604b97b005e6fb95d2ab17477e56a4b4326e74549ea1d95b4d7607ce74dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a2c7e35db07eb0e7aa1444d793074183d2078d07c4b4feaea989c7091489c6"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-dateutil"
  depends_on "python-magic"
  depends_on "python@3.12"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match ".s3cfg: None", shell_output("#{bin}/s3cmd ls s3://brewtest 2>&1", 78)
    assert_match "s3cmd version #{version}", shell_output("#{bin}/s3cmd --version")
  end
end
