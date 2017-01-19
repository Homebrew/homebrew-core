class Statik < Formula
  include Language::Python::Virtualenv

  desc "Python-based, generic static web site generator aimed at developers"
  homepage "https://getstatik.com"
  url "https://github.com/thanethomson/statik/archive/v0.14.2.tar.gz"
  sha256 "ef2e67ecf8a1a59b71b5c88b86c7335e32cc480d3156716c3b2e7691edab7620"
  head "https://github.com/thanethomson/statik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a49d5e7ed57957e706764ea751b54c6acf82628618007c7156175dc2a273e13e" => :sierra
    sha256 "4fee9d640c2ebc36c7d56b19af07f5d918bfffbce6a933d6e9984efb9d9ab112" => :el_capitan
    sha256 "478cbd81905495ee44a90d5ebf908c6258863628c10325131a94a6f9d32344e5" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "PyYAML" do
    url "https://pypi.python.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "markdown" do
    url "https://pypi.python.org/packages/d4/32/642bd580c577af37b00a1eb59b0eaa996f2d11dfe394f3dd0c7a8a2de81a/Markdown-2.6.7.tar.gz"
    sha256 "daebf24846efa7ff269cfde8c41a48bb2303920c7b2c7c5e04fa82e6282d05c0"
  end

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "lipsum" do
    url "https://pypi.python.org/packages/59/97/00636d64bc77dc173d782995de1b56dde39c70bb97112964452709b4d9aa/lipsum-0.1.2.tar.gz"
    sha256 "ba5f46cef19104c07f889b14486a3772845fc25afa1eb5e2eee1f2d9badcb8ab"
  end

  resource "future" do
    url "https://pypi.python.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/f4/3f/28387a5bbc6883082c16784c6135440b94f9d5938fb156ff579798e18eda/Jinja2-2.9.4.tar.gz"
    sha256 "aab8d8ca9f45624f1e77f2844bf3c144d180e97da8824c2a6d7552ad039b5442"
  end

  resource "Unidecode" do
    url "https://pypi.python.org/packages/ba/64/410af95d27f2a8824112d17ed41ea7ce6d2cbc8a4832c2e548d3408fad0a/Unidecode-0.04.20.tar.gz"
    sha256 "ed4418b4b1b190487753f1cca6299e8076079258647284414e6d607d1f8a00e0"
  end

  resource "python-slugify" do
    url "https://pypi.python.org/packages/63/86/ecf7b570089d794a9476c7411a06a329eb8e386f3407576640ccbe7a4698/python-slugify-1.2.1.tar.gz"
    sha256 "501182ec738cc8b743ae5c76c183f4427187ef016257f062b3fa594f60916e34"
  end

  resource "SQLAlchemy" do
    url "https://pypi.python.org/packages/da/04/8048a5075d6e29235bbd6f1ea092a38dbe2630c670e73d4aa923a4e5521c/SQLAlchemy-1.1.5.tar.gz"
    sha256 "68fb40049690e567ebda7b270176f5abf0d53d9fbd515fec4e43326f601119b6"
  end

  resource "certifi" do
    url "https://pypi.python.org/packages/4f/75/e1bc6e363a2c76f8d7e754c27c437dbe4086414e1d6d2f6b2a3e7846f22b/certifi-2016.9.26.tar.gz"
    sha256 "8275aef1bbeaf05c53715bfc5d8569bd1e04ca1e8e69608cc52bcaac2604eb19"
  end

  resource "singledispatch" do
    url "https://pypi.python.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "backports-abc" do
    url "https://pypi.python.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/1e/7c/ea047f7bbd1ff22a7f69fe55e7561040e3e54d6f31da6267ef9748321f98/tornado-4.4.2.tar.gz"
    sha256 "2898f992f898cd41eeb8d53b6df75495f2f423b6672890aadaf196ea1448edcc"
  end

  resource "argh" do
    url "https://pypi.python.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz"
    sha256 "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65"
  end

  resource "pathtools" do
    url "https://pypi.python.org/packages/e7/7f/470d6fcdf23f9f3518f6b0b76be9df16dcc8630ad409947f8be2eb0ed13a/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "watchdog" do
    url "https://pypi.python.org/packages/54/7d/c7c0ad1e32b9f132075967fc353a244eb2b375a3d2f5b0ce612fd96e107e/watchdog-0.8.3.tar.gz"
    sha256 "7e65882adb7746039b6f3876ee174952f8eaaa34491ba34333ddf1fe35de4162"
  end

  resource "httpwatcher" do
    url "https://pypi.python.org/packages/02/97/055185c6a54e470ef943556b613bc56975e82da3f456bdd08f036cf7cae8/httpwatcher-0.4.0.tar.gz"
    sha256 "2f84c93a3766a11a69f2d339f143889558bd5eccee77574593c39111a3202645"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"config.yml").write <<-EOS.undent
      project-name: Homebrew Test
      base-path: /
    EOS
    (testpath/"models/Post.yml").write("title: String")
    (testpath/"data/Post/test-post1.yml").write("title: Test post 1")
    (testpath/"data/Post/test-post2.yml").write("title: Test post 2")
    (testpath/"views/posts.yml").write <<-EOS.undent
      path:
        template: /{{ post.pk }}/
        for-each:
          post: session.query(Post).all()
      template: post
    EOS
    (testpath/"views/home.yml").write <<-EOS.undent
      path: /
      template: home
    EOS
    (testpath/"templates/home.html").write <<-EOS.undent
      <html>
      <head><title>Home</title></head>
      <body>Hello world!</body>
      </html>
    EOS
    (testpath/"templates/post.html").write <<-EOS.undent
      <html>
      <head><title>Post</title></head>
      <body>{{ post.title }}</body>
      </html>
    EOS
    system bin/"statik"

    assert(File.exist?(testpath/"public/index.html"), "home view was not correctly generated!")
    assert(File.exist?(testpath/"public/test-post1/index.html"), "test-post1 was not correctly generated!")
    assert(File.exist?(testpath/"public/test-post2/index.html"), "test-post2 was not correctly generated!")
  end
end
