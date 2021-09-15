class SpringRoo < Formula
  desc "Rapid application development tool for Java developers"
  homepage "https://projects.spring.io/spring-roo/"
  url "https://s3.amazonaws.com/spring-roo-repository.springsource.org/release/ROO/spring-roo-2.0.0.RELEASE.zip"
  version "2.0.0"
  sha256 "37819adf23b221a4544a7b1e6853b67f695fb915f5a1d433760e04fb4b5d7263"

  livecheck do
    url :homepage
    regex(/href=.*?spring-roo[._-]v?(\d+(?:\.\d+)+)\.RELEASE\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a81e84e71bc6ef221f312d8854cd852a7052516d3fbd6ea98820ddcd12e0d061"
  end

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    mv "#{libexec}/bin/roo.sh", "#{libexec}/bin/roo"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
