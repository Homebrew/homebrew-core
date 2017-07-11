class Statik < Formula
  include Language::Python::Virtualenv

  desc "Python-based, generic static web site generator aimed at developers"
  homepage "https://getstatik.com"
  url "https://github.com/thanethomson/statik/archive/v0.16.2.tar.gz"
  sha256 "e33877ec1ef8c492d32f931da94ea7d693d28c1732fbdc40c9dd363a25f7cb5a"
  head "https://github.com/thanethomson/statik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c54192f8b20b33ab2a224efcb08e6ba7c25e046ac74aabc9390917bf9fae608" => :sierra
    sha256 "1b76e4221c91d6b77aa5df52189a60929289fa439dc1a5542a5a65833deedccc" => :el_capitan
    sha256 "9b660c600692cccf9ab7230b8bad21e1c1b7a272a305b981d3530761f5e16ff8" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "statik"
    venv.pip_install_and_link buildpath
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
