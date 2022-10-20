class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "https://ftp.gnu.org/gnu/stow/stow-2.3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/stow/stow-2.3.1.tar.gz"
  sha256 "09d5d99671b78537fd9b2c0b39a5e9761a7a0e979f6fdb7eabfa58ee45f03d4b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39057770aa013dbeb401c9fe470b7fddc414d0b700972f56a7308265df3458e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6dc9f73ac8ef55caa0f8204c893bf41dcdffbae22b39d95a85eee5c99507b55"
    sha256 cellar: :any_skip_relocation, monterey:       "47c9ce7f30bb77f9458efd411f6f3c616196de21461a65c3c57068705f3b9555"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2a4d5cae000bcb2a5464f618b0c1fb174f4c90f66793411ff3c3bdda0438083"
    sha256 cellar: :any_skip_relocation, catalina:       "c99a90dc5e3db8ebcb017df044723fb4e6cce7fb94aa24cf46c8d2c0665bf9a0"
    sha256 cellar: :any_skip_relocation, mojave:         "409987564f7779d6a1db75f64e54c4713ecd9b9e006abac931f8e8d645bdac92"
    sha256 cellar: :any_skip_relocation, high_sierra:    "409987564f7779d6a1db75f64e54c4713ecd9b9e006abac931f8e8d645bdac92"
    sha256 cellar: :any_skip_relocation, sierra:         "cbc7a61940a343aff46fdb6190dc26a359d26c9c468c05b1dbde2484a066ceb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a754fc537de774792df15850b4f8252d8c88e76280ab3dfd49067588e426d061"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system "#{bin}/stow", "-nvS", "test"
  end
end
