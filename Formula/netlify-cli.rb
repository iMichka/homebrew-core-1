require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.30.4.tgz"
  sha256 "dde7ea79736fa857817b020306b7ec1559f1818c1c55d7b1eb0c868291b78627"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75687ee11fb1781b5e20f2e3c040fc76ae188bc735c7450d44605e259545a325"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d660fb7a8e9cdb2f87a8cac944d909f1d6df186d0e4457f28b96de9b3d5ac1a"
    sha256 cellar: :any_skip_relocation, catalina:      "2d660fb7a8e9cdb2f87a8cac944d909f1d6df186d0e4457f28b96de9b3d5ac1a"
    sha256 cellar: :any_skip_relocation, mojave:        "2d660fb7a8e9cdb2f87a8cac944d909f1d6df186d0e4457f28b96de9b3d5ac1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86842f4051589859e27d4ac6af22c9e7cfbbcb4b3cc3492bd40f730155293ad0"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
