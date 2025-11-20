class Tta < Formula
  desc "Lossless audio codec"
  homepage "https://sourceforge.net/projects/tta/"
  url "https://downloads.sourceforge.net/project/tta/tta/libtta/libtta-2.2.tar.gz"
  sha256 "1723424d75b3cda907ff68abf727bb9bc0c23982ea8f91ed1cc045804c1435c4"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/libtta[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f8a462551e8fec801357526eed49a963aaa646f1c9ff3cd657ec1787ac8ff9f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eaf4b5e6bf2e815f028c54bb2df0d3470f984495c16526ee8d51ea6a08c3a7fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f45089fcc147fe7133617e39ce52b106f4334b4509db14ce28ec68f8fe35cd32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48fe3083c87c3f78c9ce5d2076ed9220a18d6ba64347e5b10e739d1a08c4fce0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941f70e3d5b3b0ad8846dbdd68e074fef2094e9e9ddde9494a781b045b1da3b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd5a172d4fc33058df72affc82f3b4d0f66d147007bce62e45b429370403fb29"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a895bbe06844788d796ebe9a22d2656a7c09e6e66c0c492e6da6538e5824124"
    sha256 cellar: :any_skip_relocation, ventura:        "2dab99ae6cc3568d3b685607cbfb8b624f916d8e2bceae530fb46656509298aa"
    sha256 cellar: :any_skip_relocation, monterey:       "21fb40ccded96b6a0b51ecf1c078ddeae5b9bb116d4ce88985d4bb5b93644aae"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f2b84e5f849d0903006aa3550ec718c31130b4d50271efef0ffe37c1a29e0d2"
    sha256 cellar: :any_skip_relocation, catalina:       "af41c210ceddaa4957dc8bc4fec9dedb839157914c3d2d9fbb4bed63239cd9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30808b3d8bf5450eb396ecbf102837b9943355ea54cb6b27c052b6e2fd902adc"
  end

  # CPU aarch64 is not supported
  on_linux do
    depends_on arch: :x86_64
  end

  def install
    args = ["--disable-silent-rules"]
    if Hardware::CPU.intel?
      sse = if OS.mac? && MacOS.version.requires_sse4?
        "sse4"
      else
        "sse2"
      end
      args << "--enable-#{sse}"
    end

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end
end
