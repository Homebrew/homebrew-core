class Statik < Formula
  include Language::Python::Virtualenv

  desc "Python-based, generic static web site generator aimed at developers"
  homepage "https://getstatik.com"
  url "https://github.com/thanethomson/statik/archive/v0.21.1.tar.gz"
  sha256 "82bb2a7f48726121deb48c5c45e7a33dbf18d9e3e1d42da755796cfa26929664"
  head "https://github.com/thanethomson/statik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7774cc82e5c9340a04b9557dc2a38d00768a325cbd263c04f4b7f3163eb0b29a" => :high_sierra
    sha256 "b9741e2475bb8ad6d7066848166ef6ea3168bbfdba5488ca60b4dd1767f7c1a5" => :sierra
    sha256 "38ba964cda9586c005528c95994faf995598f497a1a2b5243753906e0a62ba8e" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  conflicts_with "go-statik", :because => "both install `statik` binaries"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "statik"
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"config.yml").write <<~EOS
      project-name: Homebrew Test
      base-path: /
    EOS
    (testpath/"models/Post.yml").write("title: String")
    (testpath/"data/Post/test-post1.yml").write("title: Test post 1")
    (testpath/"data/Post/test-post2.yml").write("title: Test post 2")
    (testpath/"views/posts.yml").write <<~EOS
      path:
        template: /{{ post.pk }}/
        for-each:
          post: session.query(Post).all()
      template: post
    EOS
    (testpath/"views/home.yml").write <<~EOS
      path: /
      template: home
    EOS
    (testpath/"templates/home.html").write <<~EOS
      <html>
      <head><title>Home</title></head>
      <body>Hello world!</body>
      </html>
    EOS
    (testpath/"templates/post.html").write <<~EOS
      <html>
      <head><title>Post</title></head>
      <body>{{ post.title }}</body>
      </html>
    EOS
    system bin/"statik"

    assert_predicate testpath/"public/index.html", :exist?, "home view was not correctly generated!"
    assert_predicate testpath/"public/test-post1/index.html", :exist?, "test-post1 was not correctly generated!"
    assert_predicate testpath/"public/test-post2/index.html", :exist?, "test-post2 was not correctly generated!"
  end
end
