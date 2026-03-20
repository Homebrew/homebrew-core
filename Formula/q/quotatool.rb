class Quotatool < Formula
  desc "Edit disk quotas from the command-line"
  homepage "https://quotatool.ekenberg.se/"
  url "https://github.com/ekenberg/quotatool.git",
      tag:      "v1.7.1",
      revision: "2a697abbc140dea5eff5aea1be8e0865369f5de9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80fc5644592b06c790eb3e6f28e3bb89c1c6abb1fa4bc778288855edc7ab65ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b7f792ec07e3c32a31d1081fd22445bc7e4dee9861bf922a5e1356151ebcf5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "765b8d0d12661ef8b6b91f782fdc2c252d4060587cdbe4901a162ca86beed8dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d0098b29dac95626f4c479f6a53c279d73c8550912cfce1e677c751772275eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f91c35d39eb2e832a3a2c7195b157a63f665f25ac2e4bebefbc2c5b27ab24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27adf194893ae8236b66f0d7906cedb0081bd85adf2c773973484e02183b1583"
  end

  on_macos do
    depends_on "coreutils" => :build # make install uses `-D` flag
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    sbin.mkpath
    man8.mkpath
    system "make", "install"
  end

  test do
    system sbin/"quotatool", "-V"
  end
end
