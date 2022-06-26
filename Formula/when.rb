class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.42.tar.gz"
  sha256 "85a8ab4df5482de7be0eb5fe1e90f738dfb8c721f2d86725dc19369b89dd839d"
  license "GPL-2.0-only"
  head "https://github.com/bcrowell/when.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6c3589de949639d5c9c678d0d5c908d6e8a2cc2e582c4c2d748888f10a4a69f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6c3589de949639d5c9c678d0d5c908d6e8a2cc2e582c4c2d748888f10a4a69f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6c3589de949639d5c9c678d0d5c908d6e8a2cc2e582c4c2d748888f10a4a69f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6c3589de949639d5c9c678d0d5c908d6e8a2cc2e582c4c2d748888f10a4a69f"
    sha256 cellar: :any_skip_relocation, catalina:       "791acd90b191f39a522ad0a9552fd90eec08dead44c2ac83e3430c3984ea333a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc448886e9bb194144c4881e6be4e3464601da149e3d5de7805f4af5c8d6559"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
