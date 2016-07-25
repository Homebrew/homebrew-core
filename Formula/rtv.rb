class Rtv < Formula
  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.10.0.tar.gz"
  sha256 "2f54e0383a65b8d771f4e4b23064126695ce23bbacee7f215393eb54f0fc453c"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe80af63d07695ee56ccbd68e065d98d3bec1c4891c25cea08f8315e7344dadd" => :el_capitan
    sha256 "cfb8ba46ded388336e617be0eaf278035acb62785be0fa978b80b5055244f412" => :yosemite
    sha256 "326f66e20d187674400db04f63b3d958d5280be25dda9e752f146634b8b35d67" => :mavericks
  end

  depends_on :python3

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/13/8a/4eed41e338e8dcc13ca41c94b142d4d20c0de684ee5065523fee406ce76f/decorator-4.0.10.tar.gz"
    sha256 "9c6e98edcb33499881b86ede07d9968c81ab7c769e28e9af24075f0a5379f070"
  end

  resource "kitchen" do
    url "https://files.pythonhosted.org/packages/d7/17/75c460f30b8f964bd5c1ce54e0280ea3ec8830a7c73a35d5036974245b2f/kitchen-1.2.4.tar.gz"
    sha256 "38f73d844532dba7b8cce170e6eb032fc07d0d04a07670e1af754bd4c91dfb3d"
  end

  resource "praw" do
    url "https://files.pythonhosted.org/packages/9b/90/2b41c0b374164a9b033093aea7c7f2b392c6333972f83156ab92a3bfbbc4/praw-3.5.0.zip"
    sha256 "0aa3da06d731ed5aa8994f34e46fb36006d168d597ddee216671369917fe8dc3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/21/29/e64c97013e97d42d93b3d5997234a6f17455f3744847a7c16289289f8fa6/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  resource "update_checker" do
    url "https://files.pythonhosted.org/packages/ae/06/84e8872337ff2c94a417eef571ac727b1cf2c98355462f7ca239d9eba987/update_checker-0.11.tar.gz"
    sha256 "681bc7c26cffd1564eb6f0f3170d975a31c2a9f2224a32f80fe954232b86f173"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
