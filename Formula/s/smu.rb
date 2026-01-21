class Smu < Formula
  desc "Simple markup with markdown-like syntax"
  homepage "https://github.com/Gottox/smu"
  url "https://github.com/Gottox/smu/archive/refs/tags/v1.5.tar.gz"
  sha256 "f3bb18f958962679a7fb48d7f8dcab8b59154d66f23c9aba02e78103106093a4"
  license "MIT"
  head "https://github.com/Gottox/smu.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ae16b75d47384735db2d4c2814049a0eee4b654e58a834b38bf6434c2a0baa91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bda27a644876f6c81baefb5ef848d760a559208664d4460eba40c95c25cb06df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9804e8317f1c9197f8cf08bd00561c1164e3d3f753820adcdca0df820caa7cae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "928be47f1fe335ea6dd656be82e8d11147b7815a4aeb7a30cdefe9bfe3911732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15a809e130f63ff833b9abb6c920c62978412ae5828719963d46290fe2920365"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35080edb3d9aebd3207eaf70a786cd1edd5676a1d6ad579ce79c8bbd355c2bb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaf8b5e63303e44a1f52e79349a985cc02c9df26c4141015bdd29de2062a5fd8"
    sha256 cellar: :any_skip_relocation, ventura:        "9aeed8b31c72a808136bc1c332eb476fecd858d454688818b09079731b7da0fe"
    sha256 cellar: :any_skip_relocation, monterey:       "77c730ecad9e261ea34baefabeffa1a90085a7b3e819c270e184dd04d9237976"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6e6dd62afe5ec17b79c60a9c4e2b7a1336c3557419c1e154d61496290c46dc2"
    sha256 cellar: :any_skip_relocation, catalina:       "3b5b9f0dbb95b72dc55a17a7966db232bf0b54d9b7b6fbf85a8fef44054ffc6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d7b6ba57e030a1e95c092e8270d8945c5f1d4fadb1f09747416f528edeb29209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc53db21e266cc248c242aeb60a653aa21a2f4fbbbd864baec3374e20aaba1e7"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.md").write "[Homebrew](https://brew.sh)"
    assert_equal "<p><a href=\"https://brew.sh\">Homebrew</a></p>\n", shell_output("#{bin}/smu test.md")
  end
end
