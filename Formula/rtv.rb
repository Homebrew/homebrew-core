class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.23.0.tar.gz"
  sha256 "66d458c37bdf377b191c899311b6b08da73312635e472cc0f55b510ad8293619"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9ea5595c96e6631001aa5f7aefa0038d36fc45d930b98c3cd395f899c3c0543" => :high_sierra
    sha256 "2fbe0e510aae31dfff08feb073e7587fd337f278c85509b302a5a5dceb101cbe" => :sierra
    sha256 "389d5872534ce6f425bc967d48dc5d8470ddf025d8d48dfd107a36acd476d242" => :el_capitan
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
