class Statik < Formula
  include Language::Python::Virtualenv

  desc "Python-based, generic static web site generator aimed at developers"
  homepage "https://getstatik.com"
  url "https://github.com/thanethomson/statik/archive/v0.18.0.tar.gz"
  sha256 "fcdac8871c44279dae284b05861f961267fdd6114d140ca08aecc9f7769c5e7b"
  head "https://github.com/thanethomson/statik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b489bd7c98323abc21d2f391f3d3e8d9164c055bb56192099d96820f1a31085" => :high_sierra
    sha256 "e0cd9ad785ac92d8caf198e258960cc933351e80db92d88ee3ddf795db00cfb5" => :sierra
    sha256 "65a8324b2e2505d4925f2036a8377e37553e85fed00bac47aea9cc75441f7aee" => :el_capitan
    sha256 "41060cbcd4e13ca6e49b52cf7890652a93d85dbd38f09ad116c47f6f8660cda4" => :yosemite
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
