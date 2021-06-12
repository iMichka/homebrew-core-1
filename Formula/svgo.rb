require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v2.3.0.tar.gz"
  sha256 "0c22647a9fba0cf80ffb5fb15e55401d62eace98a993348ee485cd8ffd4f410b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "afbccecaf1a166cb6b0fc48ef9d963daf80d7a226bcb4790b2d5583335615d68"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
