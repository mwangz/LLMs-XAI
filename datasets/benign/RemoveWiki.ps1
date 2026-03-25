[CmdletBinding(ConfirmImpact = 'Low')]
param
(
   [Parameter(Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 0,
      HelpMessage = 'Azure AD Application (client) ID')]
   [ValidateNotNullOrEmpty()]
   [Alias('OAuthClientId')]
   [string]
   $ClientId,
   [Parameter(Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 1,
      HelpMessage = 'Azure AD Tenant ID')]
   [ValidateNotNullOrEmpty()]
   [Alias('OAuthTenantId')]
   [string]
   $TenantId,
   [Parameter(Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 2,
      HelpMessage = 'Azure AD secret')]
   [ValidateNotNullOrEmpty()]
   [Alias('OAuthClientSecret')]
   [string]
   $ClientSecret
)

process
{
   $uri = 'https://login.microsoftonline.com/' + $TenantId + '/oauth2/v2.0/token'

   try
   {
      $body1 = @{
         client_id     = $ClientId
         scope         = 'https://graph.microsoft.com/.default'
         client_secret = $ClientSecret
         grant_type    = 'client_credentials'
      }

      $paramInvokeWebRequest = @{
         Method          = 'Post'
         Uri             = $uri
         ContentType     = 'application/x-www-form-urlencoded'
         Body            = $body1
         ErrorAction     = 'Stop'
         UseBasicParsing = $true
      }
      $tokenRequest = (Invoke-WebRequest @paramInvokeWebRequest)
   }
   catch
   {
      [Management.Automation.ErrorRecord]$e = $_

      $info = [PSCustomObject]@{
         Exception = $e.Exception.Message
         Reason    = $e.CategoryInfo.Reason
         Target    = $e.CategoryInfo.TargetName
         Script    = $e.InvocationInfo.ScriptName
         Line      = $e.InvocationInfo.ScriptLineNumber
         Column    = $e.InvocationInfo.OffsetInLine
      }

      $info | Out-String | Write-Verbose

      $paramWriteError = @{
         Message      = $e.Exception.Message
         ErrorAction  = 'Stop'
         Exception    = $e.Exception
         TargetObject = $e.CategoryInfo.TargetName
      }
      Write-Error @paramWriteError
   }

   $token = ($tokenRequest.Content | ConvertFrom-Json).access_token

   Write-Verbose -Message $token

   try
   {
      $uri = 'https://graph.microsoft.com/v1.0/groups'
      $paramInvokeRestMethod = @{
         Method      = 'GET'
         Uri         = $uri
         ContentType = 'application/json'
         Headers     = @{
            Authorization = 'Bearer ' + $token
         }
         ErrorAction = 'Stop'
      }
      $query = (Invoke-RestMethod @paramInvokeRestMethod)
   }
   catch
   {
      [Management.Automation.ErrorRecord]$e = $_

      $info = [PSCustomObject]@{
         Exception = $e.Exception.Message
         Reason    = $e.CategoryInfo.Reason
         Target    = $e.CategoryInfo.TargetName
         Script    = $e.InvocationInfo.ScriptName
         Line      = $e.InvocationInfo.ScriptLineNumber
         Column    = $e.InvocationInfo.OffsetInLine
      }

      $info | Out-String | Write-Verbose

      $paramWriteError = @{
         Message      = $e.Exception.Message
         ErrorAction  = 'Stop'
         Exception    = $e.Exception
         TargetObject = $e.CategoryInfo.TargetName
      }
      Write-Error @paramWriteError
   }

   $groups = $query.value

   foreach ($group in $groups)
   {
      try
      {
         if ($group.resourceProvisioningOptions -contains 'Team')
         {
            $id = $group.id

            $uri2 = 'https://graph.microsoft.com/v1.0/teams/' + $id + '/channels'

            $paramInvokeRestMethod = @{
               Method      = 'Get'
               Uri         = $uri2
               ContentType = 'application/json'
               Headers     = @{
                  Authorization = 'Bearer ' + $token
               }
            }
            $query2 = (Invoke-RestMethod @paramInvokeRestMethod)

            $Channels = $query2.value

            foreach ($Channel in $Channels)
            {
               $id2 = $Channel.id
               $uri3 = 'https://graph.microsoft.com/v1.0/teams/' + $id + '/channels/' + $id2 + '/tabs'
               $paramInvokeRestMethod = @{
                  Method      = 'Get'
                  Uri         = $uri3
                  ContentType = 'application/json'
                  Headers     = @{
                     Authorization = 'Bearer ' + $token
                  }
               }
               $query3 = (Invoke-RestMethod @paramInvokeRestMethod)

               $tabs = $query3.value

               $WikiTabs = ($tabs | Where-Object -FilterScript {
                     $PSItem.displayname -eq 'Wiki'
                  })

               if ($WikiTabs)
               {
                  foreach ($wikitab in $WikiTabs)
                  {
                     $wikitabID = $wikitab.id

                     $uri4 = 'https://graph.microsoft.com/v1.0/teams/' + $id + '/channels/' + $id2 + '/tabs/' + $wikitabID

                     $paramInvokeRestMethod = @{
                        Method      = 'DELETE'
                        Uri         = $uri4
                        ContentType = 'application/json'
                        Headers     = @{
                           Authorization = 'Bearer ' + $token
                        }
                     }
                     $query4 = (Invoke-RestMethod @paramInvokeRestMethod)

                     Write-Verbose -Message $query4

                     Write-Output -InputObject 'wikitab removed'
                  }
               }
            }
         }
      }
      catch
      {
         [Management.Automation.ErrorRecord]$e = $_

         $info = [PSCustomObject]@{
            Exception = $e.Exception.Message
            Reason    = $e.CategoryInfo.Reason
            Target    = $e.CategoryInfo.TargetName
            Script    = $e.InvocationInfo.ScriptName
            Line      = $e.InvocationInfo.ScriptLineNumber
            Column    = $e.InvocationInfo.OffsetInLine
         }

         $info | Out-String | Write-Verbose

         $paramWriteError = @{
            Message      = $e.Exception.Message
            ErrorAction  = 'Continue'
            Exception    = $e.Exception
            TargetObject = $e.CategoryInfo.TargetName
         }
         Write-Error @paramWriteError
      }
   }
}

