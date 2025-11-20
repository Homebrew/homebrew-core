class Screenresolution < Formula
  desc "Get, set, and list display resolution"
  homepage "https://github.com/jhford/screenresolution"
  url "https://github.com/jhford/screenresolution/archive/refs/tags/v1.6.tar.gz"
  sha256 "d3761663eaf585b014391a30a77c9494a6404e78e8a4863383e12c59b0f539eb"
  license "GPL-2.0-only"
  head "https://github.com/jhford/screenresolution.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9d432fd66f354ab0bd134e8062d7777d0b2cee92b84cf8331b140e307b6c65e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b35c70febc8d234c5a664507d682eeb80ff1541bde35128f42836559088e9290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e80216f98204a4f06ad9cfdcfd8fbab00c6ddfbc26773aa0920dcaf4fd86d686"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "115831028fe4da37486b48aabc70fc13fde8a297aa2e3d5eee9ea822a2727053"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "305ef97e31c6a2cdafb1a9de02787e2861b3c9de0165d45dde1c56185b8e1e64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65567f2a43d8744ca821b29e001d92b18f25750267714f4b42df0b2c24cfd3a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "578fc2c2d79a13353fdc46c1e8f0a00c2c9c7d2a4f79e80bc0942f8b649e2b31"
    sha256 cellar: :any_skip_relocation, ventura:        "25f283268c93a7d6be4fa71f4eb08c0f618206a3beaf365338d52a11af0513e9"
    sha256 cellar: :any_skip_relocation, monterey:       "961b7f2ee25f6df43ac16338dc3e7b3fc23f76985a672084c37e193e1570ad0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "234674351827f392bc7de0eb7ddb9855e6254c83a5bade7fa93b9e09ac71218b"
    sha256 cellar: :any_skip_relocation, catalina:       "53636977689925be4ef97933dc0f1b411f0cd82f71a268cfe7c6f90d5a294f97"
  end

  depends_on :macos

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"screenresolution", "get"
  end
end
