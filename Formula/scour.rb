class Scour < Formula
  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/codedread/scour/archive/v0.34.tar.gz"
  sha256 "5bf12de7acab8958531fc6b84641bbb656cc85b1517d7b28bcfa54eb84f133be"

  bottle do
    cellar :any_skip_relocation
    sha256 "6df26a6cada65c8e2c47f5ee4bfdf4ce2d75f2efdfeeb7904ed96f7392abcbbd" => :el_capitan
    sha256 "dc0f121ffd8c4b925231f1f0d82eed71ab4d99bb25030d37732995e17fe411ae" => :yosemite
    sha256 "4fc3ba5d18eef21375d17e9eac9fa2b57ff40abeba0ef31127fb3b39236d42e5" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("six").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert File.exist? "scrubbed.svg"
  end
end
