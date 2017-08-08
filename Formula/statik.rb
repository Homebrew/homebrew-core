class Statik < Formula
  include Language::Python::Virtualenv

  desc "Python-based, generic static web site generator aimed at developers"
  homepage "https://getstatik.com"
  url "https://github.com/thanethomson/statik/archive/v0.17.0.tar.gz"
  sha256 "0cb85e1bee86e6f845468cef6a09a5276861f1457bc1140014ea9cf7a68f1cd6"
  head "https://github.com/thanethomson/statik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cb3705cf9b1330b44703bedebf3e1d15693938d2fc5ea8dbf3c01233d432bbc" => :sierra
    sha256 "08b78051e13cb01f9d0890d469b5c054936392db0f065ab1cbb4d2be85fd3278" => :el_capitan
    sha256 "6f571c259f61e99992fc691548cffbfe6607b104f7af88d9935a85a0fa1705ec" => :yosemite
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
