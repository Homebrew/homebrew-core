class Symfony < Formula
  desc "Installs the Symfony framework for PHP"
  homepage "https://symfony.com/"
  url "https://github.com/symfony/cli/releases/download/v4.7.0/symfony_darwin_amd64.gz"
  version "v4.7.0"
  sha256 "c9be77cda0ee6b2f144bf8c5648a7500b01d3f4bd19d838d7a11a32be0f648b3"

  depends_on "php"
  depends_on "composer"

  def install
    bin.install "symfony" => "symfony"
  end

  test do
    assert_match /2017-2019 Symfony SAS/, shell_output("symfony -v").strip
  end
end