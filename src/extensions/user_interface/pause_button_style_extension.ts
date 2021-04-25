import { WebviewExtension } from '../webview_extension';

export class PauseButtonStyleExtension implements WebviewExtension {
  private pauseResourcePath: string;

  private playResourcePath: string;

  constructor(getWebviewResourcePath: (relativePath: string) => string) {
    this.pauseResourcePath = getWebviewResourcePath('pause.png');
    this.playResourcePath = getWebviewResourcePath('play.png');
  }

  public generateContent(): string {
    return `
      /* Container for pause button */
      .button-container, .container {
        text-align: center;
        position: absolute;
        top: 1%;
        left: 10px;
        z-index: 1;
      }

      /* Hide the browser's default checkbox */
      .button-container input {
          position: absolute;
          opacity: 0;
          cursor: pointer;
      }

      /* Custom checkbox style */
      .pause-play {
        position: absolute;
        border: none;
        padding: 13px;
        text-align: center;
        text-decoration: none;
        font-size: 16px;
        border-radius: 8px;
        margin: 0px 8px;
        transform: translateX(-50%);
        background: url(vscode-webview-resource://dd800b68-3672-4e54-8736-3762f375d3ea/file///Users/ringcrl/Documents/github/shader-factory/resources/pause.png);
        background-size: 20px;
        background-repeat: no-repeat;
        background-position: center;
        background-color: rgba(128, 128, 128, 0.5);
        z-index: 1;
        top: 1%;
      }

      
      .button-container:hover input ~ .pause-play {
          background-color: lightgray;
          transition-duration: 0.2s;
      }
      .button-container:hover input:checked ~ .pause-play {
          background-color: lightgray;
          transition-duration: 0.2s;
      }
      .button-container input:checked ~ .pause-play {
          background: url('${this.playResourcePath}');
          background-size: 20px;
          background-repeat: no-repeat;
          background-position: center;
          background-color: rgba(128, 128, 128, 0.5);
      }
    `;
  }
}
