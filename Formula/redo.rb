class Redo < Formula
  desc "Implements djb's redo: an alternative to make(1)"
  homepage "https://github.com/apenwarr/redo"
  url "https://github.com/apenwarr/redo/archive/redo-0.33.tar.gz"
  sha256 "a2ed43ad631bc33de75a274760e6163e4abe130640ff3f32832778902c29d175"

  bottle do
    cellar :any_skip_relocation
    sha256 "5471cdd4085c91f930069c8a8a315a3847739a79703758c104013ffe97a7618a" => :mojave
    sha256 "b205f9ef95a30c922d62e0deba1be29a0bbbd95d160341261711edaf49e92b82" => :high_sierra
    sha256 "630ac52a05e6b4586f1f78219bc9bce9d17cd67ab1b4acccb3d62256c2839bce" => :sierra
  end

  depends_on "mkdocs" => :build
  depends_on "python@2"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/3c/52/7bae9e99a7a4be6af4a713fe9b692777e6468d28991c54c273dfb6ec9fb2/Markdown-3.0.1.tar.gz"
    sha256 "d02e0f9b04c500cde6637c11ad7c72671f359b87b9fe924b2383649d8841db7c"
  end

  resource "BeautifulSoup" do
    url "https://files.pythonhosted.org/packages/1e/ee/295988deca1a5a7accd783d0dfe14524867e31abb05b6c0eeceee49c759d/BeautifulSoup-3.2.1.tar.gz"
    sha256 "6a8cb4401111e011b579c8c52a51cdab970041cc543814bbd9577a4529fe1cdb"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  resource "repo" do
    url "https://github.com/apenwarr/redo/archive/redo-0.33.tar.gz"
    sha256 "a2ed43ad631bc33de75a274760e6163e4abe130640ff3f32832778902c29d175"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    deps = resources.map(&:name).to_set - ["repo"]
    deps.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV["PREFIX"] = prefix
    # Fix until upstream changes mkdocs config otherwise we got following error:
    # WARNING -  Config value: 'pages'. Warning: The 'pages' configuration option has been deprecated
    # and will be removed in a future release of MkDocs. Use 'nav' instead.
    # Aborted with 1 Configuration Warnings in 'strict' mode!
    inreplace "mkdocs.yml", "pages:", "nav:"
    system "./redo", "install"
    Dir["#{bin}/*"].each do |file|
      inreplace file, "/usr/bin/python2", Formula["python@2"].opt_bin/"python2"
    end
  end

  test do
    resource("repo").stage do
      inreplace "mkdocs.yml", "pages:", "nav:"
      system "#{bin}/redo", "-j10", "test"
    end
  end
end
