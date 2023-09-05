class Screenresolution < Formula
  desc "Get, set, and list display resolution"
  homepage "https://github.com/jhford/screenresolution"
  url "https://github.com/jhford/screenresolution/archive/v1.6.tar.gz"
  sha256 "d3761663eaf585b014391a30a77c9494a6404e78e8a4863383e12c59b0f539eb"
  license "GPL-2.0-only"
  head "https://github.com/jhford/screenresolution.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "115831028fe4da37486b48aabc70fc13fde8a297aa2e3d5eee9ea822a2727053"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "305ef97e31c6a2cdafb1a9de02787e2861b3c9de0165d45dde1c56185b8e1e64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65567f2a43d8744ca821b29e001d92b18f25750267714f4b42df0b2c24cfd3a9"
    sha256 cellar: :any_skip_relocation, ventura:        "25f283268c93a7d6be4fa71f4eb08c0f618206a3beaf365338d52a11af0513e9"
    sha256 cellar: :any_skip_relocation, monterey:       "961b7f2ee25f6df43ac16338dc3e7b3fc23f76985a672084c37e193e1570ad0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "234674351827f392bc7de0eb7ddb9855e6254c83a5bade7fa93b9e09ac71218b"
    sha256 cellar: :any_skip_relocation, catalina:       "53636977689925be4ef97933dc0f1b411f0cd82f71a268cfe7c6f90d5a294f97"
    sha256 cellar: :any_skip_relocation, mojave:         "15d61e87178dbe8ef88c9cb75251f472efc42830b1a2c5be25e4a5bd074e0c66"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b2f7b0933c734d5ecd8bfafae8d384f20821c45ca38fc81308035d3ca79f3535"
    sha256 cellar: :any_skip_relocation, sierra:         "ef630f5af67d6bcdde3fd580917ad05d871274f0d62b2a76705ab2b9683f334f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "63cfb53fe13d5f5b2c72e8a644b312f8a144b12e2b3f284de5adfc5010e1570d"
  end

  depends_on :macos

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/screenresolution", "get"
  end
end
