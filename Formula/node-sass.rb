class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.34.1.tgz"
  sha256 "218aeaa96b25092757bcc55615825e1ba58d038e0734c579f9cf066b6debe291"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9256c747a7849ccbb7a113a094335c13282768cc3e52076d52a38e5d3a30572c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
